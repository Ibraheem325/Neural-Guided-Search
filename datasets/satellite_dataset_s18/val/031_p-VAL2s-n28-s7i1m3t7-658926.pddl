(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	image1 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	GroundStation1 - direction
	GroundStation4 - direction
	Star0 - direction
	Star5 - direction
	Star3 - direction
	GroundStation2 - direction
	Star6 - direction
	Planet7 - direction
	Planet8 - direction
	Planet9 - direction
	Phenomenon10 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 spectrograph0)
	(supports instrument1 image1)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument2 image1)
	(supports instrument2 spectrograph0)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
	(supports instrument3 spectrograph2)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star6)
	(supports instrument4 image1)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 Star3)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star6)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 Star6)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet8)
	(supports instrument6 spectrograph2)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 Star6)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation2)
)
(:goal (and
	(have_image Planet7 image1)
	(have_image Planet8 spectrograph2)
	(have_image Planet9 image1)
	(have_image Phenomenon10 image1)
))

)
