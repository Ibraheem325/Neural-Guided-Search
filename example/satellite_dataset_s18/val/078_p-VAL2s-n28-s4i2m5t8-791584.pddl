(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	spectrograph1 - mode
	spectrograph2 - mode
	image3 - mode
	thermograph4 - mode
	infrared0 - mode
	Star4 - direction
	Star5 - direction
	GroundStation7 - direction
	Star2 - direction
	Star6 - direction
	GroundStation3 - direction
	Star1 - direction
	Star0 - direction
	Phenomenon8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star0)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
	(supports instrument2 thermograph4)
	(supports instrument2 spectrograph2)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star9)
	(supports instrument3 spectrograph1)
	(supports instrument3 image3)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 thermograph4)
	(supports instrument4 infrared0)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 Star1)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star4)
	(supports instrument5 spectrograph2)
	(supports instrument5 infrared0)
	(supports instrument5 image3)
	(calibration_target instrument5 Star0)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star4)
)
(:goal (and
	(pointing satellite1 Star11)
	(pointing satellite3 Star1)
	(have_image Phenomenon8 thermograph4)
	(have_image Star9 infrared0)
	(have_image Star10 image3)
	(have_image Star11 infrared0)
	(have_image Phenomenon12 spectrograph1)
))

)
