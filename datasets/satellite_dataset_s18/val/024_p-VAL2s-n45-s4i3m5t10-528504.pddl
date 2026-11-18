(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	spectrograph0 - mode
	spectrograph2 - mode
	image3 - mode
	spectrograph1 - mode
	image4 - mode
	GroundStation3 - direction
	Star6 - direction
	Star4 - direction
	Star5 - direction
	Star8 - direction
	Star0 - direction
	GroundStation1 - direction
	GroundStation7 - direction
	Star9 - direction
	Star2 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Planet13 - direction
	Planet14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
	Star18 - direction
	Star19 - direction
	Star20 - direction
	Star21 - direction
	Star22 - direction
	Star23 - direction
	Planet24 - direction
	Star25 - direction
	Planet26 - direction
	Phenomenon27 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 image3)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation7)
	(supports instrument2 spectrograph2)
	(supports instrument2 image4)
	(supports instrument2 image3)
	(calibration_target instrument2 Star4)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument3 image3)
	(supports instrument3 spectrograph0)
	(supports instrument3 spectrograph1)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star5)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star0)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star8)
	(supports instrument5 spectrograph1)
	(calibration_target instrument5 Star2)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 GroundStation7)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet17)
)
(:goal (and
	(pointing satellite0 Phenomenon16)
	(pointing satellite1 Star2)
	(pointing satellite2 Star23)
	(pointing satellite3 Phenomenon29)
	(have_image Planet10 spectrograph0)
	(have_image Phenomenon11 spectrograph2)
	(have_image Star12 spectrograph0)
	(have_image Planet13 spectrograph1)
	(have_image Planet14 spectrograph2)
	(have_image Star15 spectrograph0)
	(have_image Phenomenon16 spectrograph0)
	(have_image Planet17 spectrograph0)
	(have_image Star18 spectrograph1)
	(have_image Star19 image4)
	(have_image Star20 image4)
	(have_image Star21 spectrograph2)
	(have_image Star22 spectrograph2)
	(have_image Star23 image3)
	(have_image Planet24 image3)
	(have_image Star25 spectrograph2)
	(have_image Planet26 image4)
	(have_image Phenomenon27 spectrograph1)
	(have_image Phenomenon28 spectrograph2)
	(have_image Phenomenon29 spectrograph0)
))

)
